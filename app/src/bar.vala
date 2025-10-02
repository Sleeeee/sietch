using GtkLayerShell;

[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/bar.ui")]
public class Bar : Astal.Window {
  [GtkChild]
  private unowned Hyprland hyprland;
  [GtkChild]
  private unowned Clock clock;
  [GtkChild]
  private unowned Theme theme;
  [GtkChild]
  private unowned Wireplumber wireplumber;
  [GtkChild]
  private unowned Bluetooth bluetooth;
  [GtkChild]
  private unowned Network network;
  [GtkChild]
  private unowned Battery battery;

  public Bar(Gdk.Monitor monitor) {
    Object(
      application: Application.instance,
      css_name: "bar",
      gdkmonitor: monitor
    );

    GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.LEFT, true);
    GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.TOP, true);
    GtkLayerShell.set_anchor(this, GtkLayerShell.Edge.BOTTOM, true);
  }
}
