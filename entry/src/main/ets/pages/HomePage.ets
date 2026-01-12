import { map, mapCommon, MapComponent } from '@kit.MapKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { SiteService } from '../services/SiteService';
import { LocationService } from '../services/LocationService';
import type { Place } from '../common/types';
import { SearchInput } from '../components/SearchInput';
import { PoiCard } from '../components/PoiCard';

@Entry
@Component
export struct HomePage {
  private pathStack: NavPathStack = new NavPathStack();
  private mapController?: map.MapComponentController;

  private mapOptions: mapCommon.MapOptions = {
    position: { target: { latitude: 38.447967, longitude: 27.179380 }, zoom: 13 }
  };
  private results: Place[] = [];

  private myLocationMarker: mapCommon.MarkerOptions = {
    position: { latitude: 38.447967, longitude: 27.179380},
    icon: $r('app.media.Vector'),
    title: 'Mistral Izmir',
    clickable: true,
    anchorU: 0.5,
    anchorV: 1,
    alpha: 1
  };

  async onSearch(keyword: string) {
    const center = this.mapOptions.position.target;
    this.results = await SiteService.searchPlaces(keyword, center);
  }

  async aboutToAppear() {
    const location = await LocationService.getCurrentLocationSafe();
    if (location) {
      this.mapOptions = {
        position: { target: location, zoom: 18 }
      };
      this.myLocationMarker.position = location;
    }
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Scroll() {
          Column() {
          }
        }
        MapComponent({
          mapOptions: this.mapOptions,
          mapCallback: async (err: BusinessError, ctrl: map.MapComponentController) => {
            if (!err) {
              this.mapController = ctrl;
              await ctrl?.addMarker(this.myLocationMarker);
            }
          }
        })
          .width('130%')
          .height(180)
          .margin({ top: 2 })
      }
      .padding(12)
    }
    .hideTitleBar(true)
    .hideToolBar(true)

  }
}