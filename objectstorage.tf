#
# objectstorage.tf#


resource "oci_objectstorage_bucket" "objectstorage_bucket" {
    compartment_id = var.root_compartment
    namespace = local.objectstorage_ns
    name = "scripts-storage"
    access_type = "NoPublicAccess"
    versioning = "Disabled"
}

resource "oci_objectstorage_object" "objectstorage_file_rc-firewall" {
    bucket = "scripts-storage"
    namespace = local.objectstorage_ns    
       
    object = "rc-firewall.sh"
    source = "./vm-firewall/scripts/rc-firewall.sh"
    content_type = "text/plain"

    depends_on = [
        oci_objectstorage_bucket.objectstorage_bucket
    ]  
}