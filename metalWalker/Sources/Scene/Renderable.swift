protocol Renderable {
    var transformComponent: TransformComponent { get set }
    var materialComponent: MaterialComponent { get set }
    func intersect(ray: Ray) -> Intersection?
}
