import dotenv from 'dotenv';
import cors from 'cors';
import morgan from 'morgan';
import multer from 'multer';
import express, { Application } from 'express';
import Router from './routes';

dotenv.config();

class App {
	public app: Application;
	private readonly router: Router;

	constructor() {
		this.app = express();
		this.router = new Router(this.app);
		this.initializeMiddlewares();
	}

	private initializeMiddlewares(): void {
		this.app.use(cors());
		this.app.use(express.json());
		this.app.use(morgan('dev'));
		this.app.use(multer().any());
	}

	/**
	 * Initializes the routes asynchronously before starting the server.
	 */
	public async initialize(): Promise<void> {
		await this.router.initializeRoutes();
	}
}

// Create an instance and export it
const appInstance = new App();
export default appInstance;
