import { Router } from 'express';

export abstract class BaseApiRoutes {
	public router: Router;
	protected basePath: string;

	constructor(basePath: string) {
		this.router = Router();
		this.basePath = basePath;
		this.initializeRoutes();
	}

	/**
	 * Abstract method to initialize routes in derived classes.
	 * Derived classes must implement this method.
	 */
	protected abstract initializeRoutes(): void;

	/**
	 * Automatically adds RESTful routes for common actions (index, show, create, update, destroy)
	 * if the corresponding methods exist in the derived class.
	 * Each route can have middleware for authentication, authorization, or validation.
	 *
	 * @param controller - The controller class that contains the route methods
	 * @param middlewares - Optional middleware array to be added to each route
	 */
	protected addRestRoutes(controller: any, middlewares: { [key: string]: Function[] } = {}): void {
		const methods = Object.getOwnPropertyNames(controller.prototype);

		// Index Route
		if (methods.includes('index')) {
			const indexMiddlewares = middlewares['index'] || [];
			this.router.get(`${this.basePath}`, [...indexMiddlewares, controller.prototype.index]);
		}

		// Show Route
		if (methods.includes('show')) {
			const showMiddlewares = middlewares['show'] || [];
			this.router.get(`${this.basePath}/:id`, [...showMiddlewares, controller.prototype.show]);
		}

		// Create Route
		if (methods.includes('create')) {
			const createMiddlewares = middlewares['create'] || [];
			this.router.post(`${this.basePath}`, [...createMiddlewares, controller.prototype.create]);
		}

		// Update Route
		if (methods.includes('update')) {
			const updateMiddlewares = middlewares['update'] || [];
			this.router.put(`${this.basePath}/:id`, [...updateMiddlewares, controller.prototype.update]);
		}

		// Destroy Route
		if (methods.includes('destroy')) {
			const destroyMiddlewares = middlewares['destroy'] || [];
			this.router.delete(`${this.basePath}/:id`, [...destroyMiddlewares, controller.prototype.destroy]);
		}
	}
}
