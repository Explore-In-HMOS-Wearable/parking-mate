import geoLocationManager from '@ohos.geoLocationManager';
import preferences from '@ohos.data.preferences';
import { common } from '@kit.AbilityKit';
import { PromptAction } from '@kit.ArkUI';

@Entry
@Component
struct HomePage {
  @State isParked: boolean = false;
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  async toggleLocation() {

    if (!this.isParked) {
      try {
        const location = await geoLocationManager.getCurrentLocation({
          priority: geoLocationManager.LocationRequestPriority.LOW_POWER
        });

        const context = this.getUIContext().getHostContext() as common.UIAbilityContext;

        const pref = await preferences.getPreferences(context, 'parkingPref');
        await pref.put('parkingLocation', JSON.stringify({
          lat: location.latitude,
          lon: location.longitude,
          alt: location.altitude || 0
        }));
        await pref.flush();
        this.promptAction.showToast({
          message: 'Parking location saved.',
          duration: 30
        });
        this.isParked = true;
      } catch (err) {
        this.promptAction.showToast({
          message: 'Failed to get location.',
          duration: 30
        });
      }
    } else {
      this.promptAction.showToast({
        message: 'Navigating to saved location...',
        duration: 30
      });
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