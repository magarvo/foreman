require 'test_helper'

class Queries::UsergroupsQueryTest < ActiveSupport::TestCase
  test 'fetching usergroups attributes' do
    FactoryBot.create_list(:usergroup, 2)

    query = <<-GRAPHQL
      query {
        usergroups {
          totalCount
          pageInfo {
            startCursor
            endCursor
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
            }
          }
        }
      }
    GRAPHQL

    context = { current_user: FactoryBot.create(:user, :admin) }
    result = ForemanGraphqlSchema.execute(query, variables: {}, context: context)

    expected_count = Usergroup.count

    assert_empty result['errors']
    assert_equal expected_count, result['data']['usergroups']['totalCount']
    assert_equal expected_count, result['data']['usergroups']['edges'].count
  end
end
