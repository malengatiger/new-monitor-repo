import Project from "../models/project";
import Settlement from "../models/settlement";
import Position from "../models/position";

export class ProjectHelper {
  public static async onProjectAdded(event: any) {
    console.log(
      `operationType: 👽 👽 👽  ${
        event.operationType
      },  Project in stream:   🍀 🍎 `,
    );
  }
  public static async addProject(
    name: string,
    description: string,
    organizationId: string,
    organizationName: string,
    settlements: any[],
    positions: any[],
  ): Promise<any> {
    const ProjectModel = new Project().getModelForClass(Project);
    const u = new ProjectModel({
      name,
      description,
      organizationId,
      organizationName,
      settlements,
      positions,
    });
    const m = await u.save();
    m.projectId = m.id;
    await m.save();
    return m;
  }
  public static async addSettlementToProject(
    projectId: string,
    settlementId: string,
    settlementName: string,
  ): Promise<any> {
    const projectModel = new Project().getModelForClass(Project);

    const m = {
      settlementId,
      settlementName,
    };
    projectModel.findOneAndUpdate(
      { _id: projectId },
      { $push: { settlements: m } },
      () => (error: any, success: any) => {
        if (error) {
          console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
          console.error(error);
        } else {
          console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
          console.log(success);
        }
      },
    );
    const u: any = await projectModel.findByProjectId(projectId).exec();
    return u;
  }
  public static async addPositionToProject(
    projectId: string,
    latitude: number,
    longitude: number,
  ): Promise<any> {
    const projectModel = new Project().getModelForClass(Project);
    const position = new Position();
    position.coordinates = [longitude, latitude];
    projectModel.findOneAndUpdate(
      { _id: projectId },
      { $push: { positions: position } },
      () => (error: any, success: any) => {
        if (error) {
          console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
          console.error(error);
        } else {
          console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
          console.log(success);
        }
      },
    );
    const u: any = await projectModel.findByProjectId(projectId).exec();
    return u;
    return u;
  }
  public static async addProjectPhoto(
    projectId: string,
    url: string,
    latitude: number,
    longitude: number,
    userId: string,
  ): Promise<any> {
    const projectModel = new Project().getModelForClass(Project);
    const position = new Position();
    position.coordinates = [longitude, latitude];
    const m = {
      url,
      position,
      created: new Date().toISOString(),
      userId,
    };
    projectModel.findOneAndUpdate(
      { _id: projectId },
      { $push: { photoUrls: m } },
      () => (error: any, success: any) => {
        if (error) {
          console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
          console.error(error);
        } else {
          console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
          console.log(success);
        }
      },
    );
    const u: any = await projectModel.findByProjectId(projectId).exec();
    return u;
  }
  public static async addProjectVideo(
    projectId: string,
    url: string,
    comment: string,
    latitude: number,
    longitude: number,
    userId: string,
  ): Promise<any> {
    const projectModel = new Project().getModelForClass(Project);
    const u: any = await projectModel.findByProjectId(projectId).exec();
    const position = new Position();
    position.coordinates = [longitude, latitude];
    const m = {
      url,
      position,
      userId,
      comment,
    };
    projectModel.findOneAndUpdate(
      { _id: projectId },
      { $push: { videoUrls: m } },
      () => (error: any, success: any) => {
        if (error) {
          console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
          console.error(error);
        } else {
          console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
          console.log(success);
        }
      },
    );
    return {
      message: `Video added to project`,
    };
  }

  public static async addProjectRating(
    projectId: string,
    rating: number,
    comment: string,
    latitude: number,
    longitude: number,
    userId: string,
  ): Promise<any> {
    const projectModel = new Project().getModelForClass(Project);
    const u: any = await projectModel.findByProjectId(projectId).exec();
    const position = new Position();
    position.coordinates = [longitude, latitude];
    const m = {
      rating,
      created: new Date().toISOString(),
      position,
      userId,
      comment,
    };
    projectModel.findOneAndUpdate(
      { _id: projectId },
      { $push: { ratings: m } },
      () => (error: any, success: any) => {
        if (error) {
          console.log(`🔆🔆🔆🔆🔆🔆 error has occured`);
          console.error(error);
        } else {
          console.log(`🥦🥦🥦🥦🥦🥦 success has occured`);
          console.log(success);
        }
      },
    );
    return {
      message: `Rating added to project`,
    };
  }

  public static async findAllProjects(): Promise<any> {
    console.log(` 🌀 getProjects ....   🌀  🌀  🌀 `);
    const ProjectModel = new Project().getModelForClass(Project);
    const list = await ProjectModel.find();
    return list;
  }
  public static async findByProject(ProjectId: string): Promise<any> {
    console.log(` 🌀 findByProject ....   🌀  🌀  🌀 `);
    const ProjectModel = new Project().getModelForClass(Project);
    const list = await ProjectModel.findByProjectId(ProjectId);
    return list;
  }
  public static async findByOrganization(organizationId: string): Promise<any> {
    console.log(` 🌀 findByCountry ....   🌀  🌀  🌀 `);
    const ProjectModel = new Project().getModelForClass(Project);
    const list = await ProjectModel.findByOrganization(organizationId);
    return list;
  }
}
