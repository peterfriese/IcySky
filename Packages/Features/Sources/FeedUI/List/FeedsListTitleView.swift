import Network
import SwiftUI

public struct FeedsListTitleView: View {
  @Binding var filter: FeedsListFilter
  @Binding var searchText: String
  @Binding var isInSearch: Bool
  var isSearchFocused: FocusState<Bool>.Binding
  
  public init(
    filter: Binding<FeedsListFilter>,
    searchText: Binding<String>,
    isInSearch: Binding<Bool>,
    isSearchFocused: FocusState<Bool>.Binding
  ) {
    self._filter = filter
    self._searchText = searchText
    self._isInSearch = isInSearch
    self.isSearchFocused = isSearchFocused
  }

  public var body: some View {
    HStack(alignment: .center) {
      if !isInSearch {
        Menu {
          ForEach(FeedsListFilter.allCases) { filter in
            Button(action: {
              self.filter = filter
            }) {
              Label(filter.rawValue, systemImage: filter.icon)
            }
          }
        } label: {
          HStack {
            VStack(alignment: .leading, spacing: 2) {
              Text("Feeds")
                .foregroundStyle(
                  .primary.shadow(
                    .inner(
                      color: .shadowSecondary.opacity(0.5),
                      radius: 1, x: -1, y: -1))
                )
                .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 1)
                .font(.title)
                .fontWeight(.bold)
              Text(filter.rawValue)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            VStack(spacing: 6) {
              Image(systemName: "chevron.up")
              Image(systemName: "chevron.down")
            }
            .imageScale(.large)
            .offset(y: 2)
          }
        }
        .buttonStyle(.plain)
        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading))
          .combined(with: .opacity))

        Spacer()
      }
      
      FeedsListSearchField(
        searchText: $searchText,
        isInSearch: $isInSearch,
        isSearchFocused: isSearchFocused
      )
      .onTapGesture {
        isInSearch.toggle()
        isSearchFocused.wrappedValue = true
      }
    }
    .animation(.smooth, value: isInSearch)
    .transition(.slide)
  }
}

#Preview {
  FeedsListView()
    .environment(BSkyClient.preview())
}
