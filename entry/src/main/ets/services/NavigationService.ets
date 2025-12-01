import { navi, type mapCommon } from '@kit.MapKit';
import { LocationService } from './LocationService';

export class NavigationService {
  static async getDrivingRouteTo(destination: mapCommon.LatLng): Promise<navi.RouteResult | null> {
    try {
      const currentLocation = await LocationService.getCurrentLocationSafe();
      if (!currentLocation) {
        console.error('Current location unavailable.');
        return null;
      }

      const params: navi.DrivingRouteParams = {
        origins: [currentLocation],
        destination: destination,
        language: 'en'
      };

      const result = await navi.getDrivingRoutes(params);
      console.info('Driving route received.');
      return result;
    } catch (error) {
      console.error('Error fetching route:', error);
      return null;
    }
  }
}
