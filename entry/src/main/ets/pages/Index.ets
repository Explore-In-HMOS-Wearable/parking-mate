// Main screen using ArkTS for HarmonyOS smartwatch
import geoLocationManager from '@ohos.geoLocationManager';
import promptAction from '@ohos.promptAction';
import preferences from '@ohos.data.preferences';

@Entry
@Component
struct HomePage {
  @State isParked: boolean = false;

  async toggleLocation() {

    if (!this.isParked) {
      try {
        const location = await geoLocationManager.getCurrentLocation({
          priority: geoLocationManager.LocationRequestPriority.LOW_POWER
        });

        const context = this.context;
        const pref = await preferences.getPreferences(context, 'parkingPref');
        await pref.put('parkingLocation', JSON.stringify({
          lat: location.latitude,
          lon: location.longitude,
          alt: location.altitude || 0
        }));
        await pref.flush();

        promptAction.showToast({ message: 'Parking location saved.' });
        this.isParked = true;
      } catch (err) {
        promptAction.showToast({ message: 'Failed to get location.' });
      }
    } else {
      // Navigation logic will be added later
      promptAction.showToast({ message: 'Navigating to saved location...' });
      this.isParked = false;
    }
  }

  build() {
    Stack() {
      Circle()
        .width(200)
        .height(200)
        .backgroundColor(Color.Black)

      Button(this.isParked ? 'Go' : 'Save')
        .width(120)
        .height(120)
        .backgroundColor(this.isParked ? Color.Green : Color.Red)
        .fontColor(Color.White)
        .fontSize(22)
        .borderRadius(60)
        .onClick(() => this.toggleLocation())
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
    .align(Alignment.Center)
  }
}