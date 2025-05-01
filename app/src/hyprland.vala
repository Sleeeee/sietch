[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/hyprland.ui")]
public class Hyprland : Gtk.Box {
  public AstalHyprland.Hyprland hyprland;
  private HashTable<int, Gtk.Button> workspace_buttons;

  private void map_workspaces(GLib.List<weak AstalHyprland.Workspace> workspaces) {
    workspaces.sort((x, y) => x.id - y.id);
    List<int> active_ids = new List<int>();
    foreach (weak AstalHyprland.Workspace workspace in workspaces) {
      active_ids.append(workspace.id);
      if (!workspace_buttons.contains(workspace.id)) {
        WorkspaceButton? last_button = this.get_last_child() as WorkspaceButton;
        WorkspaceButton workspace_button = new WorkspaceButton(workspace);
        if (last_button == null) {
          this.append(workspace_button);
        } else {
          while (last_button != null && last_button.workspace_id > workspace.id) {
            last_button = last_button.get_prev_sibling() as WorkspaceButton;
          }
          this.insert_child_after(workspace_button, last_button);
        }
        workspace_buttons[workspace.id] = workspace_button;
      }
    }
    workspace_buttons.foreach_remove((id, button) => {
      if (active_ids.index(id) == -1) {
        this.remove(button);
        return true;
      }
      return false;
    });
  }

  private void set_focused_workspace_class(int focused_id) {
    workspace_buttons.foreach((id, button) => {
      if (focused_id == id) {
        if (!button.has_css_class("focused")) { button.add_css_class("focused"); }
      } else {
        if (button.has_css_class("focused")) { button.remove_css_class("focused"); }
      }
    });
  }

  construct {
    this.hyprland = AstalHyprland.get_default();
    this.workspace_buttons = new HashTable<int, Gtk.Button>(direct_hash, direct_equal);
    this.hyprland.notify["workspaces"].connect(() => { map_workspaces(this.hyprland.workspaces); });
    this.hyprland.notify["focused-workspace"].connect(() => { set_focused_workspace_class(this.hyprland.focused_workspace.id); });
    map_workspaces(this.hyprland.workspaces);
    set_focused_workspace_class(this.hyprland.focused_workspace.id);
  }
}
