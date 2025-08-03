defmodule AveloDataWeb.HomeLive do
  use AveloDataWeb, :live_view

  alias Phoenix.LiveView.ColocatedHook

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div
        id="map"
        class="w-full h-full"
        phx-hook=".Leaflet"
        data-icon-path={static_path(@socket, "/images/marker-icon.png")}
        data-shadow-path={static_path(@socket, "/images/marker-shadow.png")}
      >
        <div
          :for={station <- @stations}
          :key={station.id}
          id={station.id}
          class="hidden"
          data-station
          data-lat={station.geolocation.latitude}
          data-lon={station.geolocation.longitude}
        />
      </div>
    </Layouts.app>
    <script :type={ColocatedHook} name=".Leaflet">
      export default {
        mounted() {
          const map = L.map(this.el).setView([46.800991, -71.2883398], 13);
          L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
              maxZoom: 19,
              attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
          }).addTo(map);

          const icon = L.icon({
            iconUrl: this.el.dataset.iconPath,
            shadowUrl: this.el.dataset.shadowPath
          });
          [...this.el.children]
            .filter(it => it.dataset.station !== undefined)
            .forEach(it => {
              const lat = it.dataset.lat;
              const lon = it.dataset.lon;
              L.marker([lat, lon], { icon }).addTo(map)
            })
        }
      }
    </script>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    stations =
      if connected?(socket), do: AveloData.StationStatusFinder.find() |> elem(1), else: []

    socket = assign(socket, stations: stations)

    {:ok, socket}
  end
end
