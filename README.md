# OnFrame

A modifier for SwiftUI to get callbacks on every frame update (based on `CADisplayLink`).

## Usage

The above example uses the a callback.

````swift
import SwiftUI
import OnFrame

struct SampleView: View {
  @State var timestamp: TimeInterval
  
  var body: some View {
    Text("\(self.timestamp)")
      .onFrame { _ /* last frame timestamp */, timestamp /* target frame timestamp */ in
        self.timestamp = timestamp
      }
  }
}
````

Another way to use it is to just add the modifier and then get values using an environment value.

````swift
import SwiftUI
import OnFrame

struct FrameView: View {
  @Environment(\.timestamp) var timestamp
  
  var body: some View {
    Text("\(self.timestamp)")
  }
}

struct MainView: View {
  var body: some View {
    FrameView()
      .onFrame()
  }
}
````

# License

See license in LICENSE.
