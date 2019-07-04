import {
  prop,
  Typegoose,
} from "typegoose";
import Position from './position';
import { Content, RatingContent } from "./interfaces";

enum ProjectType {
  Infrastructure = 'Infrastructure',
  Social = 'Social',
  Educational = 'Educational',
  Health = 'Health',
  Other = 'Other',
}

class Project extends Typegoose {
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
  @prop({ trim: true })
  public settlementId?: string;
  //
  @prop({ trim: true })
  public settlementName?: string;
  
  @prop({ required: false })
  public position?: Position;
  //
  @prop({ required: true, default: [] })
  public photoUrls!: Content[];
  //
  @prop({ required: true, default: [] })
  public videoUrls!: Content[];
  //
  @prop({ required: true, default: [] })
  public comments!: Content[];
  //
  @prop({ required: true, default: [] })
  public ratings!: RatingContent[];
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;
  //
}

export default Project;
