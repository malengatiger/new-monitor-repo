
import Project from "../models/project";
import Settlement from "../models/settlement";

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
