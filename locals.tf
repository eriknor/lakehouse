/*
################################################################################
* Owner: Erik Nor

* Usage:
*   Any local variables should be defined here
*   
*
################################################################################
*/

locals {

  /* Catalog Configurations */
  catalog_list_yaml = yamldecode(file("${path.module}/uc_catalogs.yaml"))

}
