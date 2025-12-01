import site from '@hms.core.map.site';
import { Place } from '../common/types';
import mapCommon from '@hms.core.map.mapCommon';
export class SiteService {
  static async searchPlaces(keyword: string, center: mapCommon.LatLng): Promise<Place[]> {
    const result: site.SearchByTextResult = await site.searchByText({
      query: keyword,
      location: center,
      radius: 5000,
      language: 'en'
    });

    return result.sites?.map((s: site.Site): Place => {
      return new Place(s);
    }) ?? [];
  }
}
