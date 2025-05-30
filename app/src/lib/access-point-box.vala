[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/access-point-box.ui")]
public class AccessPointBox : Gtk.Box {
  public unowned AstalNetwork.AccessPoint access_point { get; construct; }

  [GtkChild]
  private unowned Gtk.Label ssid_label;

  public AccessPointBox(AstalNetwork.AccessPoint access_point) {
    Object(access_point: access_point);
  }

  construct {
    ssid_label.label = access_point.ssid;
  }
}
