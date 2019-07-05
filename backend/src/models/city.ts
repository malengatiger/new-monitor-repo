import {
  prop,
  Typegoose,
} from "typegoose";
import Settlement from "./settlement";
import Position from './position';

class City extends Typegoose {
  //
  @prop({ required: true, index: true, trim: true })
  public name?: string;
  //
  @prop({ required: true })
  public provinceName?: string;
  
  @prop({ required: true, index: true, trim: true })
  public countryId!: string;

  @prop({ index: true, trim: true })
  public cityId?: string;
  //
  @prop({ required: true, index: true, trim: true })
  public countryName?: string;
  //
  @prop({ required: true })
  public latitude?: number;
  //
  @prop({ required: true })
  public longitude?: number;
  //
  @prop({ required: true })
  public position?: Position;
  //
  @prop({ required: true, default: new Date().toISOString() })
  public created?: string;
  //
}

export default City;
