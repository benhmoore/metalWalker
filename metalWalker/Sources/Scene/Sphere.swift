import simd

struct Sphere: Renderable {
    var transformComponent: TransformComponent
    var materialComponent: MaterialComponent
    var radius: Float

    func intersect(ray: Ray) -> Intersection? {
        let oc = ray.origin - transformComponent.transform.position
        let a = dot(ray.direction, ray.direction)
        let b = 2.0 * dot(oc, ray.direction)
        let c = dot(oc, oc) - radius * radius
        let discriminant = b * b - 4 * a * c
        
        if discriminant > 0 {
            let t = (-b - sqrt(discriminant)) / (2.0 * a)
            if t > 0 {
                let position = ray.origin + t * ray.direction
                let normal = normalize(position - transformComponent.transform.position)
                return Intersection(position: position, normal: normal, distance: t, material: materialComponent.material)
            }
        }
        return nil
    }
}
