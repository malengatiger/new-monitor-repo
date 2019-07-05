
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
  ): Promise<any> {
    const ProjectModel = new Project().getModelForClass(Project);
    const u: any = await ProjectModel.findByProjectId(projectId).exec();
    await u.addSettlement(projectId, settlementId);
    return u;
  }
 public static async addPositionsToProject(
    projectId: string,
    positions: any[],
  ): Promise<any> {
    const ProjectModel = new Project().getModelForClass(Project);
    const u: any = await ProjectModel.findByProjectId(projectId).exec();
    await u.addPositions(projectId, positions);
    return u;
  }
  public static async addProjectPhoto(
    projectId: string,
    url: string,
    comment: string,
    latitude: number,
    longitude: number,
    userId: string,
  ): Promise<any> {
    const projectModel = new Project().getModelForClass(Project);
    const u: any = await projectModel.findByProjectId(projectId).exec();
    const  position  = new Position();
    position.coordinates = [longitude, latitude];
    await u.photoUrls.push({
      url,
      comment,
      position,
      userId,
    });
    await u.save();
    return {
      message: `Photo added to project`,
    };
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
    const  position  = new Position();
    position.coordinates = [longitude, latitude];
    await u.videoUrls.push({
      url,
      comment,
      position,
      userId,
    });
    await u.save();
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
    const  position  = new Position();
    position.coordinates = [longitude, latitude];
    await u.ratings.push({
      rating,
      comment,
      position,
      userId,
    });
    await u.save();
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
