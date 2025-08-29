[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/device-box.ui")]
public class DeviceBox : Gtk.Box {
  public unowned AstalBluetooth.Device device { get; construct; }

  [GtkChild]
  private unowned Gtk.Image device_icon;
  [GtkChild]
  private unowned Gtk.Label alias_label;
  [GtkChild]
  private unowned Gtk.Image connected_icon;

  [GtkCallback]
  public void toggle_connection() {
    if (this.device.connected) {
      this.device.disconnect_device();
    } else {
      this.device.connect_device();
    }
  }

  public DeviceBox(AstalBluetooth.Device device) {
    Object(device: device);
  }

  private void set_connected_icon(bool connected) {
    if (connected) {
      connected_icon.icon_name = "media-playback-stop-symbolic";
    } else {
      connected_icon.icon_name = "media-playback-start-symbolic";
    }
  }

  construct {
    device_icon.icon_name = this.device.icon + "-symbolic";
    alias_label.label = this.device.alias;
    this.device.notify["connected"].connect(() => { set_connected_icon(this.device.connected); });
    set_connected_icon(this.device.connected);
  }
}
