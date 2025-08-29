[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/network.ui")]
public class Network : Gtk.Box {
  public AstalNetwork.Wifi wifi { get; private set; }
  public Gtk.Adjustment adjustment { get; private set; }
  private uint timeout;
  private HashTable<string, AccessPointBox> access_points_map;

  [GtkChild]
  private unowned CircularProgress network_progress;
  [GtkChild]
  private unowned Gtk.Image network_icon;
  [GtkChild]
  private unowned Gtk.Popover network_popover;
  [GtkChild]
  private unowned Gtk.Label ipv4_label;
  [GtkChild]
  private unowned Gtk.Label ipv6_label;
  [GtkChild]
  private unowned Gtk.Box access_points_container;

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
    this.adjustment.value = (double)strength / 100.0;
  }

  private void check_ip_protocol(ref bool searching, NM.IPConfig? ip_config, Gtk.Label label, string ip_version) {
    if (searching && ip_config != null) {
      GenericArray<NM.IPAddress>? addresses = ip_config.addresses;
      if (addresses != null && addresses.length > 0) {
        string address = addresses[0].get_address();
        uint? prefix = addresses[0].get_prefix();
        if (address != null) {
          label.label = "%s/%u".printf(address, prefix);
          searching = false;
        }
      } else {
        // No address found but non-null config, continue checking
        label.label = "No %s address assigned".printf(ip_version);
      }
    } else {
      // Stop searching for IPv4 if not supported
      searching = false;
      label.label = "%s unsupported".printf(ip_version);
    }
  }

  private void start_searching_ip_addresses(AstalNetwork.DeviceState state) {
    if (state.to_string() == "activated") {
      bool searching_ipv4 = true;
      bool searching_ipv6 = true;
      this.timeout = GLib.Timeout.add(5000, () => {
        if (this.wifi.state.to_string() == "activated") {
          NM.ActiveConnection? active_connection = this.wifi.active_connection;
          if (active_connection != null) {
            check_ip_protocol(ref searching_ipv4, active_connection.ip4_config, this.ipv4_label, "IPv4");
            check_ip_protocol(ref searching_ipv6, active_connection.ip6_config, this.ipv6_label, "IPv6");
            if (searching_ipv4 || searching_ipv6) {
              return GLib.Source.CONTINUE;
            }
            return GLib.Source.REMOVE;
          }
        }
        // Interface was de-activated
        this.ipv4_label.label = "Interface not activated";
        this.ipv6_label.label = "Interace not activated";
        return GLib.Source.REMOVE;
      });
    } else {
      this.ipv4_label.label = "Interface not activated";
      this.ipv6_label.label = "Interface not activated";
    }
  }

  private void map_access_points(GLib.List<weak AstalNetwork.AccessPoint> access_points, AstalNetwork.AccessPoint? active_access_point) {
    HashTable<string, bool> active_ssids = new HashTable<string, bool>(str_hash, str_equal);
    foreach (weak AstalNetwork.AccessPoint access_point in access_points) {
      if (access_point.ssid != null && (active_access_point == null || active_access_point.ssid != access_point.ssid)) {
        active_ssids.insert(access_point.ssid, true);
        if (!this.access_points_map.contains(access_point.ssid)) {
          AccessPointBox access_point_box = new AccessPointBox(access_point);
          this.access_points_container.append(access_point_box);
          this.access_points_map[access_point.ssid] = access_point_box;
        }
      }
    }
    this.access_points_map.foreach_remove((ssid, box) => {
      if (!active_ssids.contains(ssid)) {
        this.access_points_container.remove(box);
        return true;
      }
      return false;
    });
  }

  construct {
    this.wifi = AstalNetwork.get_default().wifi;
    this.adjustment = new Gtk.Adjustment((double)this.wifi.strength / 100.0, 0, 1, 0, 0, 0);
    this.wifi.notify["strength"].connect(() => { set_adjustment_value(this.wifi.strength); });
    this.wifi.state_changed.connect((state) => {
      set_state_class(state);
      start_searching_ip_addresses(state);
    });
    start_searching_ip_addresses(this.wifi.state);
    this.access_points_map = new HashTable<string, AccessPointBox>(str_hash, str_equal);
    this.wifi.notify["access-points"].connect(() => { map_access_points(this.wifi.access_points, this.wifi.active_access_point); });
    map_access_points(this.wifi.access_points, this.wifi.active_access_point);
  }

  public override void dispose() {
    if (this.timeout > 0) {
      GLib.Source.remove(this.timeout);
      this.timeout = 0;
    }
    base.dispose();
  }
}
