public class WorkspaceButton : Gtk.Button {
  public unowned AstalHyprland.Workspace workspace { get; construct; }

  public WorkspaceButton(AstalHyprland.Workspace workspace) {
    Object(workspace: workspace);
    Gtk.Label label = new Gtk.Label(workspace.id.to_string());
    this.set_child(label);
    this.clicked.connect(() => { workspace.focus(); });
  }

  public int workspace_id {
    get { return this.workspace.id; }
  }
}
