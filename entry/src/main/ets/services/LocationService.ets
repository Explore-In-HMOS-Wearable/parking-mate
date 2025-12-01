import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, Permissions, bundleManager, common, PermissionRequestResult } from '@kit.AbilityKit';
import { mapCommon, map } from '@kit.MapKit';
import { BusinessError } from '@kit.BasicServicesKit';
import GlobalContext from './GlobalContext';

export class LocationService {
  private mapController?: map.MapComponentController;

  async checkPermissions(): Promise<boolean> {
    const permissions: Array<Permissions> = ['ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION'];
    for (let permission of permissions) {
      let grantStatus: abilityAccessCtrl.GrantStatus = await this.checkAccessToken(permission);
      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        this.mapController?.setMyLocationEnabled(true);
        this.mapController?.setMyLocationControlsEnabled(true);
        return true;
      }
    }
    return false;
  }

  static async getCurrentLocationSafe(): Promise<mapCommon.LatLng> {
    const fallbackLocation: mapCommon.LatLng = {
      latitude: 38.447967,
      longitude: 27.179380 // Mistral İzmir
    };

    const service = new LocationService();
    const granted = await service.checkPermissions();
    if (!granted) {
      console.warn('Location permission not granted. Requesting now...');
      LocationService.requestPermissions();
      return fallbackLocation;
    }

    try {
      const location = await geoLocationManager.getCurrentLocation();
      return {
        latitude: location.latitude,
        longitude: location.longitude
      };
    } catch (error) {
      console.error('Error fetching current location:', error);
      console.warn('Using fallback default location.');
      return fallbackLocation;
    }
  }


  static requestPermissions(): void {
    const atManager = abilityAccessCtrl.createAtManager();
    const context = GlobalContext.getInstance().getSavedContext();
    atManager.requestPermissionsFromUser(context, [
      'ohos.permission.LOCATION',
      'ohos.permission.APPROXIMATELY_LOCATION'
    ])
      .then(() => {
        console.info('Permissions granted by user.');
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to request permissions: ${err.message}`);
      });
  }


  async checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

    let tokenId: number = 0;
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    console.info('Succeeded in getting Bundle.');
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;

    grantStatus = await atManager.checkAccessToken(tokenId, permission);
    console.info('Succeeded in checking access token.');
    return grantStatus;
  }
}