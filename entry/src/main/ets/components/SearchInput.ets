import type { Place } from '../common/types';

interface IParams {
  siteId: string;
  name: string;
}

@Component
export struct PoiCard {
  private pathStack: NavPathStack = new NavPathStack();
  @Prop place: Place;

  build() {
    NavDestination() {
      Column() {
        Text(this.place.name ?? 'Unknown')
          .fontSize(16)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
        Text(this.place.address ?? '')
          .fontSize(12)
          .opacity(0.6)
          .fontColor(Color.Black)
      }
      .padding(12)
      .backgroundColor('#F5F5F5')
      .borderRadius(12)
      .margin({ bottom: 8 })
      .onClick(() => {
        const params: IParams = { siteId: this.place.siteId, name: this.place.name }
        this.pathStack.pushPath({ name: 'PlaceDetailPage', param: params });
      })
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
    })

  }
}
