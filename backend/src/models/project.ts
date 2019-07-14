import {
  prop,
  Typegoose,
  ModelType,
  staticMethod,
  instanceMethod,
} from "typegoose";
import Position from './position';
import { Content, RatingContent } from "./interfaces";
import Settlement from "./settlement";

enum ProjectType {
  Infrastructure = 'Infrastructure',
  Social = 'Social',
  Educational = 'Educational',
  Health = 'Health',
  Other = 'Other',
}

class Project extends Typegoose {
  @staticMethod
  public static findByOrganization(
    this: ModelType<Project> & typeof Project,
    organizationId: string,
  ) {
    return this.find({ organizationId });
  }
   @staticMethod
  public static findByProjectId(
    this: ModelType<Project> & typeof Project,
    projectId: string,
  ) {
    return this.findOne({ projectId });
  }
   
  //
  //
  @prop({ index: true, trim: true })
  public projectId?: string;
  //
  @prop({ required: true, index: true, trim: true })
  public name?: string;
  //
  @prop({ required: true, index: true, trim: true })
  public description?: string;
  //
  @prop({ required: true, trim: true })
  public organizationId!: string;
  //
  @prop({ required: true, trim: true })
  public organizationName!: string;
  //
  @prop({ required: true, default: [] })
  public settlements?: any[];
  //
  @prop({ required: true, default: [] })
  public nearestCities?: any[];
  
  @prop({ required: true, default: [] })
  public positions?: Position[];
  //
  @prop({ required: true})
  public position?: Position;
  //
  @prop({ required: true, default: [] })
  public photoUrls!: Content[];
  //
  @prop({ required: true, default: [] })
  public videoUrls!: Content[];
  //
  @prop({ required: true, default: [] })
  public ratings!: RatingContent[];
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;
  //
  @instanceMethod
  public  async addSettlement(
    this: ModelType<Project> & typeof Project,
    projectId: string,
    settlementId: string,
  ) {

    const proj: any = this.findOne({ projectId }).exec();
    const settlementModel = new Settlement().getModelForClass(Settlement);
    const stlmt: any = settlementModel.findBySettlementId(settlementId);
    if  (proj && stlmt) {
      proj.settlements.push({
        settlementId: stlmt.settlementId,
        settlementName: stlmt.settlementName,
      })

      await proj.save();
      const msg = `settlement ${stlmt.settlementName} added to project ${proj.name}`;
      console.log(msg);
      return {
        message: msg,
      }

    } else {
      const msg = `missing or invalid data`;
      console.error(msg);
      throw new Error(msg);
    }

  }
  @instanceMethod
  public  async addPositions(
    this: ModelType<Project> & typeof Project,
    projectId: string,
    positions: any[],
  ) {

    const proj: any = this.findOne({ projectId }).exec();
    if  (proj ) {
      const list: Position[] = [];
      positions.forEach((p) => {
        const pos  = new Position();
        pos.coordinates = [p.longitude, p.latitude];
        list.push(pos);
      });

      await proj.save();
      const msg = `${list.length} positions added to project ${proj.name}`;
      console.log(msg);
      return {
        message: msg,
      }

    } else {
      const msg = `missing or invalid data`;
      console.error(msg);
      throw new Error(msg);
    }
  }
}

export default Project;
