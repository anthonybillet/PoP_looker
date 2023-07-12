include: "/_base_views_do_not_edit/order_items.view.lkml"

view: +order_items {

dimension: test_dim {
  view_label: "A Test"
}

}
