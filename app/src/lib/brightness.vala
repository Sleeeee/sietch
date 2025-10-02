public class Brightness : Object {
  private string _backlight_model;
  private int _max_brightness;
  private double _brightness;
  public GLib.FileMonitor _file_monitor;

  public double brightness {
    get { return this._brightness; }
    set {
      if (value != this._brightness) {
        value = value.clamp(0.0, 1.0);
        int file_value = (int)(value * this._max_brightness);

        try {
          GLib.File file = GLib.File.new_for_path("/sys/class/backlight/" + this._backlight_model + "/brightness");
          file.replace_contents(file_value.to_string().data, null, false, GLib.FileCreateFlags.NONE, null, null);
        } catch (Error e) {
          critical(e.message);
        }
      }
    }
  }

  private void refresh_brightness(GLib.FileMonitor monitor, GLib.File file, GLib.File? other_file, GLib.FileMonitorEvent event_type) {
    if (event_type == FileMonitorEvent.CHANGES_DONE_HINT) {
      try {
        uint8[] contents;
        file.load_contents(null, out contents, null);
        string string_contents = (string)contents;
        this._brightness = int.parse(string_contents.strip()) / (double)this._max_brightness;
        this.notify_property("brightness");

      } catch (Error e) {
        critical(e.message);
      }
    }
  }

  construct {
    try {
      GLib.File dir = GLib.File.new_for_path("/sys/class/backlight/");
      if (dir != null) {
        GLib.FileEnumerator enumerator = dir.enumerate_children("standard::*", GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
        GLib.FileInfo info = enumerator.next_file();
        this._backlight_model = info?.get_name();
        enumerator.close_async();
      }

      GLib.File max_brightness_file = GLib.File.new_for_path("/sys/class/backlight/" + this._backlight_model + "/max_brightness");
      GLib.File brightness_file = GLib.File.new_for_path("/sys/class/backlight/" + this._backlight_model + "/brightness");

      uint8[] contents;
      string string_contents;

      max_brightness_file.load_contents(null, out contents, null);
      string_contents = (string)contents;
      this._max_brightness = int.parse(string_contents.strip());
      brightness_file.load_contents(null, out contents, null);
      string_contents = (string)contents;
      this._brightness = int.parse(string_contents.strip()) / (double)this._max_brightness;

      this._file_monitor = brightness_file.monitor_file(GLib.FileMonitorFlags.NONE);
      this._file_monitor.changed.connect(refresh_brightness);

    } catch (Error e) {
      critical("%s\n", e.message);
    }
  }
}
