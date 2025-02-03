import { Request, Response, NextFunction, Router } from 'express';
import { ApiRouteNotFoundError } from '../errors';

class ErrorHandler {
	public router: Router;

	constructor() {
		this.router = Router();
		this.initializeRoutes();
	}

	private initializeRoutes() {
		// Catch-all for undefined API endpoints
		this.router.use((req: Request, res: Response, next: NextFunction) => {
			next(new ApiRouteNotFoundError(`Route ${req.originalUrl} not found`));
		});

		// Global error handling middleware
		this.router.use((err: any, req: Request, res: Response, next: NextFunction) => {
			if (err instanceof ApiRouteNotFoundError) {
				res.status(err.statusCode).send(err.json());
			} else {
				res.status(500).send({ status: 'error', message: 'Internal Server Error' });
			}
		});
	}
}

export default new ErrorHandler().router;
