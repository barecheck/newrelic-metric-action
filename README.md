# newrelic-metric-action

Github Action to send Barecheck metric events to newrelic

## Inputs

| Key            | Required | Default | Description                                                                                                                            |
| -------------- | -------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `accountId`    | **yes**  | -       | The account to post test run results to. This could also be a subaccount.                                                              |
| `region`       | no       | US      | The region the account belongs to. Posible Options: `US`, `EU`                                                                         |
| `insertApiKey` | **yes**  | -       | Your New Relic [Insert API key](https://docs.newrelic.com/docs/apis/get-started/intro-apis/types-new-relic-api-keys#event-insert-key). |
| `metricName`   | **yes**  | -       | Your Barecheck metric that you would like to receive as an event                                                                       |
| `metricValue`  | **yes**  | -       | Barecheck metric value.                                                                                                                |

## Example usage

#### Post test run results to New Relic

The following example will post barecheck custom events of type `Barecheck` to New Relic based on the metric name and value.

Github secrets assumed to be set:

- `NEW_RELIC_ACCOUNT_ID` - New Relic Account ID to post the event data to
- `NEW_RELIC_INSERT_API_KEY` - Insert API key

```yaml
name: Send Test New Relic Metric

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Sends New Relic test metric
        id: newrelic-metric
        uses: barecheck/newrelic-metric-action@v0.1-beta.1
        with:
          insertApiKey: ${{ secrets.NEW_RELIC_INSERT_API_KEY }}
          accountId: ${{ secrets.NEW_RELIC_ACCOUNT_ID }}
          region: EU
          metricName: "testMetric"
          metricValue: 45.6
```

#### Querying the data

Data can be queried in New Relic One [Chart Builder](https://docs.newrelic.com/docs/chart-builder/use-chart-builder/get-started/introduction-chart-builder) or with the [New Relic CLI](https://github.com/newrelic/newrelic-cli) via the `newrelic nrql query` command:

```
newrelic nrql query --accountId 12345 --query 'SELECT * from Barecheck'
```

#### Build New Relic Dashboards

Dashboard isgreat choice tp combine all your code metrics together. Here is a few examples what you can build with barecheck metrics.

- Code coverage dashboard to know current code coverage in your application

```
SELECT latest(value) as '%' FROM Barecheck WHERE metric='codeCoverage' SINCE 1 month ago
```
