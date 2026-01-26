resource "helm_release" "external_nginx" {
    name = "external"

    repository          = "https://kubernetes.github.io/ingress-nginx"
    chart               = "ingress-nginx"
    namespace           = "ingress"
    create_namespace    = true

    values              = [file("./../../Modules/K8s_eks_addons/external_nginx_ingress/values/nginx-ingress.yaml")]
    
}