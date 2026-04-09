// Global declarations for the OmniFocus plugin execution context.
//
// The Omni Automation runtime exposes Database properties as top-level
// globals when running inside a plugin. The official OmniFocus.d.ts
// only declares them as Database members, so this file bridges the gap.

declare const flattenedFolders: FolderArray;
declare const flattenedProjects: ProjectArray;
declare const flattenedSections: SectionArray;
declare const flattenedTags: TagArray;
declare const flattenedTasks: TaskArray;
declare const folders: FolderArray;
declare const inbox: Inbox;
declare const library: Library;
declare const projects: ProjectArray;
declare const tags: Tags;

declare function moveTasks(
  tasks: Array<Task>,
  position: Project | Task | Task.ChildInsertionLocation,
): void;
declare function duplicateTasks(
  tasks: Array<Task>,
  position: Project | Task | Task.ChildInsertionLocation,
): TaskArray;
declare function convertTasksToProjects(
  tasks: Array<Task>,
  position: Folder | Folder.ChildInsertionLocation,
): Array<Project>;
declare function moveSections(
  sections: Array<Project | Folder>,
  position: Folder | Folder.ChildInsertionLocation,
): void;
declare function duplicateSections(
  sections: Array<Project | Folder>,
  position: Folder | Folder.ChildInsertionLocation,
): SectionArray;
declare function moveTags(
  tags: Array<Tag>,
  position: Tag | Tag.ChildInsertionLocation,
): void;
declare function duplicateTags(
  tags: Array<Tag>,
  position: Tag | Tag.ChildInsertionLocation,
): TagArray;
declare function deleteObject(object: DatabaseObject): void;
declare function tagNamed(name: string): Tag | null;
declare function folderNamed(name: string): Folder | null;
declare function projectNamed(name: string): Project | null;
declare function taskNamed(name: string): Task | null;
declare function save(): void;
declare function cleanUp(): void;
declare function undo(): void;
declare function redo(): void;
