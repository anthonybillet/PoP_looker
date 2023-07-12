include: "/_base_views_do_not_edit/order_items.view.lkml"
include: "/explores_and_logic/PoP_params.view.lkml"

explore: order_items  {
  label: "Orders with PoP"
  join: PoP_params  {
    type: left_outer
    sql:  ;;
    relationship: one_to_one
  }
  join: Pop_params_order_items  {
    type: left_outer
    sql:  ;;
    relationship: one_to_one
  }

sql_always_where:
    {% if Pop_params_order_items.order_created_in_current_previous_period._in_query %}
      ${Pop_params_order_items.order_created_in_current_previous_period} != 'Outside Current and Previous Period' AND ${order_items.created_date} BETWEEN ${PoP_params.previous_period_start} AND ${PoP_params.current_period_end}
    {% else %}
    {% endif %}
  ;;
}

view: Pop_params_order_items  {

  view_label: "Z) Period over Period Parameters"

  dimension: order_created_in_current_previous_period {
    label: "Order Created in Which Period? (Current or Previous)"
    type: string
    case: {
      when: {
        label: "Current Period"
        sql: ${order_items.created_date} BETWEEN ${PoP_params.current_period_start} AND ${PoP_params.current_period_end} ;;
      }
      when: {
        label: "Previous Period"
        sql: ${order_items.created_date} BETWEEN ${PoP_params.previous_period_start} AND ${PoP_params.previous_period_end} ;;
      }
      else: "Outside Current and Previous Period"
    }
  }
}
