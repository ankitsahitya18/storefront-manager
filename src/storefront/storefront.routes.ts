import { StorefrontController } from './storefront.controller';
import { BaseApiRoutes } from '../common/base.routes';

class StorefrontRoutes extends BaseApiRoutes {
	constructor() {
		super('/storefronts');
	}

	protected initializeRoutes(): void {
		this.addRestRoutes(StorefrontController, {
			index: [],
			show: [],
			create: [],
			update: [],
			destroy: [],
		});
	}
}

export default new StorefrontRoutes().router;
