import { BaseController } from '../common/base.controller';
import { Storefront } from '../models';

export class StorefrontController extends BaseController {
	constructor() {
		super(Storefront);
	}
}
