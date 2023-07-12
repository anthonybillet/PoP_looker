view: PoP_params {
  view_label: "Z) Period over Period Parameters"

  filter: current_date_range {
    type: date
    label: "Current Date Range"
    description: "Select the current date range you are interested in. Make sure any other filter on Date covers this period, or is removed."
  }

  dimension: current_period_start {
    # hidden:  yes
    description: "Calculates the start of the previous period"
    type: date
    convert_tz: no
    sql:{% date_start current_date_range %};;
  }

  dimension: current_period_end {
    # hidden:  yes
    description: "Calculates the start of the previous period"
    type: date
    convert_tz: no
    sql:DATE_ADD({% date_end current_date_range %},INTERVAL -1  DAY);;
  }


  dimension: days_in_period {
    # hidden:  yes
    description: "Gives the number of days in the current period date range"
    type: duration_day
    convert_tz: no
    sql_start: ${current_period_start} ;;
    sql_end: DATE_ADD(${current_period_end}, INTERVAL 1  DAY)  ;;
  }


  dimension: previous_period_start {
    # hidden:  yes
    description: "Calculates the start of the previous period"
    type: date
    convert_tz: no
    sql:DATE_ADD(${current_period_start},INTERVAL -${days_in_period}  DAY);;
  }

  dimension: previous_period_end {
    # hidden:  yes
    description: "Calculates the start of the previous period"
    type: date
    convert_tz: no
    sql:DATE_ADD(${current_period_start},INTERVAL -1  DAY);;
  }

  set: pop_nuetral_fields {
    fields: [current_date_range,current_period_start,current_period_end, previous_period_start, previous_period_end, days_in_period]
  }

}

#Add this to your Model file or .explore file
# include: "/_base_views_do_not_edit/order_items.view.lkml"
# include: "/explores_and_logic/PoP_params.view.lkml"

# explore: +your_existing_explore_you_want_to_add_pop_to  {
#   join: PoP_params  {
#     type: left_outer
#     sql:  ;;
#   relationship: one_to_one
# }
# join: Pop_params_your_table_with_the_date_for_pop  {
#   type: left_outer
#   sql:  ;;
# relationship: one_to_one
# }

# sql_always_where:
#     {% if Pop_params_your_table_with_the_date_for_pop.your_date_field_in_current_previous_period._in_query %}
#       ${Pop_params_your_table_with_the_date_for_pop.your_date_field_in_current_previous_period} != 'Outside Current and Previous Period' AND ${your_view.your_date_date} BETWEEN ${PoP_params.previous_period_start} AND ${PoP_params.current_period_end}
#     {% else %}
#     {% endif %}
#   ;;
# }

# view: Pop_params_your_table_with_the_date_for_pop  {

#   view_label: "Z) Period over Period Parameters"

#   dimension: your_date_field_in_current_previous_period {
#     label: "Order Createad in Which Period? (Current or Previous)"
#     type: string
#     case: {
#       when: {
#         label: "Current Period"
#         sql: ${your_view.your_date_date} BETWEEN ${PoP_params.current_period_start} AND ${PoP_params.current_period_end} ;;
#       }
#       when: {
#         label: "Previous Period"
#         sql: ${your_view.your_date_date} BETWEEN ${PoP_params.previous_period_start} AND ${PoP_params.previous_period_end} ;;
#       }
#       else: "Outside Current and Previous Period"
#     }
#   }
# }
