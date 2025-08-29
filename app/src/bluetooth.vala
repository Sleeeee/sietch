[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/bluetooth.ui")]
public class Bluetooth : Gtk.Box {
  public AstalBluetooth.Bluetooth bluetooth { get; private set; }
  public Gtk.Adjustment adjustment { get; private set; }
  private HashTable<string, DeviceBox> devices_map;

  [GtkChild]
  private unowned CircularProgress bluetooth_progress;
  [GtkChild]
  private unowned Gtk.Popover bluetooth_popover;
  [GtkChild]
  private unowned Gtk.Box devices_container;

  [GtkCallback]
  public void toggle_popover() {
    this.bluetooth_popover.popup();
  }

  private void increment_adjustment_value(bool connected) {
    double increment = (connected) ? 1.0 : -1.0;
    this.adjustment.set_value(this.adjustment.value + increment / 7.0);
  }

  private void map_devices(GLib.List<weak AstalBluetooth.Device> devices) {
    foreach (weak AstalBluetooth.Device device in devices) {
      increment_adjustment_value(device.connected);
      device.notify["connected"].connect(() => { increment_adjustment_value(device.connected); });
      DeviceBox device_box = new DeviceBox(device);
      this.devices_container.append(device_box);
      this.devices_map[device.alias] = device_box;
    }
  }

  construct {
    this.bluetooth = AstalBluetooth.get_default();
    this.adjustment = new Gtk.Adjustment(0, 0, 1, 0, 0, 0);
    this.devices_map = new HashTable<string, DeviceBox>(str_hash, str_equal);
    this.bluetooth.notify["devices"].connect(() => { map_devices(this.bluetooth.devices); });
    map_devices(this.bluetooth.devices);
  }
}
