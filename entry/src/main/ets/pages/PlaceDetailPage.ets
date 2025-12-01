import { map, mapCommon, MapComponent } from '@kit.MapKit';
import { BusinessError } from '@kit.BasicServicesKit';
import site from '@hms.core.map.site';
import { NavigationService } from '../services/NavigationService';

interface RouterParams {
  siteId?: string;
}

@Builder
function placeDetailPageBuilder() {
  PlaceDetailPage()
}

@Component
export struct PlaceDetailPage {
  private mapController?: map.MapComponentController;
  @State mapOptions?: mapCommon.MapOptions | null = null;
  @State markerOptions?: mapCommon.MarkerOptions | null = null;
  private destination?: mapCommon.LatLng;

  build() {
    NavDestination() {
      Column() {
        Text('Place Details')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .padding(8)
          .width('100%')
          .textAlign(TextAlign.Center)
        if (this.mapOptions) {
          Column() {
            MapComponent({
              mapOptions: this.mapOptions,
              mapCallback: async (err: BusinessError, ctrl: map.MapComponentController) => {
                if (!err) {
                  this.mapController = ctrl;
                  if (this.markerOptions) {
                    await ctrl?.addMarker(this.markerOptions);
                  }
                }
              }
            })
              .width('130%')
              .height(200)

            Row() {
              Image($r('app.media.navi'))
                .onClick(() => this.onRoutePress())
                .width(24)
                .height(24)
            }
            .padding(4)
            .borderRadius(10)
            .backgroundColor(Color.Black)
            .margin({ top: -190, left: -150 })
          }

        } else {
          Text('Loading map...')
            .width('100%')
            .textAlign(TextAlign.Center)
        }
      }
      .padding(12)
    }
    .hideTitleBar(true)
    .hideToolBar(true)
    .onReady((ctx: NavDestinationContext) => {
      const params: RouterParams = ctx?.pathInfo?.param as RouterParams;
      const siteId = params.siteId;

      site.searchById({ siteId }).then(result => {
        const siteData = result.site;
        if (siteData && siteData.location) {
          this.destination = siteData.location;
          this.mapOptions = {
            position: {
              target: siteData.location,
              zoom: 15
            }
          };
          this.markerOptions = {
            position: siteData.location,
            title: siteData.name ?? ''
          };
        }
      });
    })
  }

  async onRoutePress() {
    if (!this.destination || !this.mapController) {
      return;
    }

    const routeResult = await NavigationService.getDrivingRouteTo(this.destination);

    if (routeResult && routeResult.routes?.length > 0) {
      const route = routeResult.routes[0];
      if (route.overviewPolyline) {
        const polyline: mapCommon.MapPolylineOptions = {
          points: route.overviewPolyline,
          width: 10,
          color: 0xFF0A84FF
        };
        await this.mapController.addPolyline(polyline);
      }
    }
  }
}