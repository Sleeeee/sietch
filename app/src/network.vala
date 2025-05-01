[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/network.ui")]
public class Network : Gtk.Box {
  public AstalNetwork.Wifi wifi { get; private set; }
  public Gtk.Adjustment adjustment { get; private set; }

  [GtkChild]
  private unowned CircularProgress network_progress;
  [GtkChild]
  private unowned Gtk.Image network_icon;
  [GtkChild]
  private unowned Gtk.Popover network_popover;

  [GtkCallback]
  public void toggle_popover() {
    this.network_popover.popup();
  }

  private void set_state_class(AstalNetwork.DeviceState state) {
    if (state.to_string() == "activated") {
      if (this.network_progress.has_css_class("warning")) { this.network_progress.remove_css_class("warning"); }
      if (this.network_icon.has_css_class("warning")) { this.network_icon.remove_css_class("warning"); }
    } else {
      if (!this.network_progress.has_css_class("warning")) { this.network_progress.add_css_class("warning"); }
      if (!this.network_progress.has_css_class("warning")) { this.network_progress.add_css_class("warning"); }
    }
  }

  private void set_adjustment_value(uint8 strength) {
    this.adjustment.value = (float)strength / 100.0;
  }

  construct {
    this.wifi = AstalNetwork.get_default().wifi;
    this.adjustment = new Gtk.Adjustment((float)this.wifi.strength / 100.0, 0, 1, 0, 0, 0);
    this.wifi.notify["state"].connect(() => { set_state_class(this.wifi.state); });
    this.wifi.notify["strength"].connect(() => { set_adjustment_value(this.wifi.strength); });
  }
}
