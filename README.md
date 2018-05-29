# React Functional Router

#### What if the url was just an object?

Getting the parts of the url would just be destructuring:
```
// myapp.com/Reports/2017/feb?sort=asc&items=2&sidepanel=true

const {path0: page, path1: year, path2: month, sort, items, sidepanel} = url

// page = 'Report'
// year = 2017
// month = 'feb'
// sort = 'asc'
// items = 2
// sidepanel = true
```

Changing the url would just be applying a function to the current url:
 
```
// currentUrl = myapp.com/Reports/2017/feb?sort=asc&items=2&sidepanel=true

newUrl = R.assoc('sidepanel', false, currentUrl)

// newUrl = 'myapp.com/Reports/2017/feb?sort=asc&items=2&sidepanel=false'
```

#### react-functional-router is built on exactly these two principles!

It gives you the simplest router api ever, and saves some complexity-space in your brain to put where it's better needed than routing :)


#### Semi-full Flux/Redux example

```
const store = createFluxStore() // Generic flux store to show the principle

const router = createRouter({onUrlChange: (delta, url) => {
  // delta = only the changes eg. {sidepanel: false}
  // url = full object eg. {path0, path1, path2, sort, items, sidepanel}
  store.setData({urlObject: url})
  // Note that we are here putting the url data in our flux store to have
  // both application data and url data in the same place.
}})

const App = () => (
  <RouterProvider router={router}>
    <FluxProvider store={store}>
      <Body />
    </FluxProvider>
  </RouterProvider>
)

const Body = connectToFlux()(({urlObject}) => {
  const {path0: page} = urlObject
  <div>
     {(() => {
        switch(page) {
          case 'Report':
            return <ReportPage />
          case 'Profile':
            return <ProfilePage />
          default:
            return <NotFoundPage />
        }
      })()}
  </div>
})

const ReportPage = connectToFlux()(({urlObject, reportData}) => {
  const {path0: page, path1: year, path2: month} = urlObject
  <div>
  </div>
})

```

#### Semi-full Apollo example

```
const router = createRouter()

const App = () => (
  <RouterProvider router={router}>
    <Body />
  </RouterProvider>
)

const Body = withRouter(({url}) => {
  const {path0: page} = url
  return (
    <div>
      {(() => {
        switch(page) {
          case 'Report':
            return <ReportPage />
          case 'Profile':
            return <ProfilePage />
          default:
            return <NotFoundPage />
        }
      })()}
    </div>
  )
})

const ReportPage = withRouter(({url: {path1: year}}) => {
  <Query query=gql`
    query reportByYear($year: Int!) {
      reportByYear(year: $year) {
        id
        name
        monthlyData
      }
    }
    variables={{year}}
  `>
    {({reportByYear}) => (
      <div> ... </div>
    )}
  </Query>
})

```



See full examples in the [examples folder](/examples)

---

> **NOTE: This is experimental**. If you like the idea of the functional API, you could just create two helpers `changeUrlWithFunction` and `parseUrlIntoObject` and make them work with a more stable router like [React-Router](https://reacttraining.com/react-router/)
