import { CustomError } from './customError';

export class ApiRouteNotFoundError extends CustomError {
	statusCode = 404;

	constructor(message: string = 'API Route does not found.') {
		super(message, 'ApiRouteNotFoundError');
	}
}
