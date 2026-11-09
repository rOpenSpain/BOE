attrs2matrix <- function(cat) {
    o <- do.call(rbind, xml_attrs(cat))
    p <- rep(seq_along(cat), times = xml_length(cat))
    o[p, , drop = FALSE]
}
