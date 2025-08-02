defmodule AveloDataWeb.HomeLive do
  use AveloDataWeb, :live_view

  alias Phoenix.LiveView.ColocatedJS

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div>hello {length(@stations)}</div>
      <div id="map" class="w-full h-full" phx-hook="LeafletMap" />
      <div
        :for={station <- @stations}
        :key={station.station_id}
        id={station.station_id}
        class="hidden"
        data-lat={elem(station.geolocation.coordinates, 0)}
        data-lon={elem(station.geolocation.coordinates, 1)}
        data-icon-path={static_path(@socket, "/images/marker-icon.png")}
        data-shadow-path={static_path(@socket, "/images/marker-shadow.png")}
        phx-hook="LeafletStation"
      />
    </Layouts.app>
    <script :type={ColocatedJS} name="__Hooks__Leaflet">
      let map;
      export default {
        "LeafletMap": {
          mounted() {
            map = L.map(this.el).setView([46.800991, -71.2883398], 13);
            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }).addTo(map);
          }
        },
        "LeafletStation": {
          mounted() {
            const icon = L.icon({
              iconUrl: this.el.dataset.iconPath,
              shadowUrl: this.el.dataset.shadowPath
            });
            setTimeout(() => {
              const lat = this.el.dataset.lat;
              const lon = this.el.dataset.lon;
              L.marker([lat, lon], { icon }).addTo(map)
            }, 0)
          }
        }
      }
    </script>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    stations = if connected?(socket), do: AveloData.StationStatusFinder.find(), else: []

    socket = assign(socket, stations: stations)

    {:ok, socket}
  end
end
