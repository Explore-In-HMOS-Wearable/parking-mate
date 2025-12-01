import mapCommon from '@hms.core.map.mapCommon';
import { site } from '@kit.MapKit';
export class Place {
  siteId: string = '';
  name: string = '';
  address: string = '';
  location: mapCommon.LatLng = { latitude: 0, longitude: 0 };

  constructor(site?: site.Site) {
    if (site) {
      this.siteId = site.siteId;
      this.name = site.name ?? '';
      this.address = site.formatAddress ?? '';
      this.location = site.location!;
    }
  }
}

export interface LatLng {
  longitude: number;
  latitude: number;
}