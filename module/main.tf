module "vpc" {
    source                                      = "./VPC"
    vpc_cidr_block                              = var.vpc_cidr_block
    subnet_cidr                                 = var.subnet_cidr
    private_subnet_1_cidr                       = var.private_subnet_1_cidr 
    private_subnet_2_cidr                       = var.private_subnet_2_cidr
    availability_zone                           = var.availability_zone
    private_1_availability_zone                 = var.private_1_availability_zone
    private_2_availability_zone                 = var.private_2_availability_zone
    map_public_ip_on_launch                     = var.map_public_ip_on_launch
    map_public_ip_on_launch_private             = var.map_public_ip_on_launch_private
}                                                                               

module "Ec2" {
    source                                      = "./EC2"
    vpc_id                                      = module.vpc.vpc_id
    subnet_id_public                            = module.vpc.subnet_public_id
    subnet_id_tomcat                            = module.vpc.subnet_tomcat_id
    subnet_id_database                          = module.vpc.subnet_database_id  
    private_ip_public                           = var.private_ip_public
    private_ip_tomcat                           = var.private_ip_tomcat
    private_ip_database                         = var.private_ip_database
    ssh                                         = var.ssh
    http                                        = var.http
    https                                       = var.https
    tomcat                                      = var.tomcat
    mariadb                                     = var.mariadb 
    ami_id                                      = var.ami_id
    instance_type                               = var.instance_type
    key_name                                    = var.key_name
}

module "RDS" {
    source                                      = "./RDS"
    vpc_id                                      = module.vpc.vpc_id
    subnet_id_database                          = module.vpc.subnet_database_id
    subnet_id_public                            = module.vpc.subnet_public_id
    subnet_id_tomcat                            = module.vpc.subnet_tomcat_id
    security_group_id                           = module.Ec2.security_group_id
    name                                        = var.name
    engine                                      = var.engine
    engine_version                              = var.engine_version
    instance_class                              = var.instance_class
    username                                    = var.username
    password                                    = var.password
    db_allocated_storage                        = var.db_allocated_storage
}