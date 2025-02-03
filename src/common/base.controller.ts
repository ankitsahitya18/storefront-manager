import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { CustomError, NotFoundError, UnprocessableEntityError } from '../errors';

export abstract class BaseController {
	private readonly prisma: PrismaClient;
	private readonly modelName: string;

	constructor(modelName: string) {
		this.prisma = new PrismaClient();
		this.modelName = modelName;
	}

	/**
	 * Fetch all records for the model with pagination and filtering.
	 */
	public async index(req: Request, res: Response): Promise<void> {
		try {
			// Get pagination parameters from the query string
			const page = parseInt(req.query.page as string) || 1; // Default to page 1
			const limit = parseInt(req.query.limit as string) || 10; // Default to 10 items per page

			// Calculate the number of records to skip for pagination
			const skip = (page - 1) * limit;

			// Call the getFilters method to handle dynamic filter logic
			const filters = this.getFilters(req);

			// Perform the query with filtering and pagination
			const records = await this.prisma[this.modelName].findMany({
				where: filters, // Apply filters
				skip: skip, // Pagination: Skip the appropriate number of records
				take: limit, // Pagination: Limit the number of records returned
			});

			// Get the total count of records for pagination metadata
			const totalRecords = await this.prisma[this.modelName].count({
				where: filters, // Apply filters
			});

			// Send the response with records and pagination metadata
			res.json({
				data: records,
				pagination: {
					page: page,
					limit: limit,
					totalRecords: totalRecords,
					totalPages: Math.ceil(totalRecords / limit),
				},
			});
		} catch (error) {
			this.handleError(error, res);
		}
	}
	/**
	 * Fetch a single record by ID for the model.
	 */
	public async show(req: Request, res: Response): Promise<void> {
		const { id } = req.params;
		try {
			const record = await this.prisma[this.modelName].findUnique({
				where: { id: Number(id) },
			});

			if (!record) {
				throw new NotFoundError(`${this.modelName} with ID ${id} not found`);
			}

			res.json(record);
		} catch (error) {
			this.handleError(error, res);
		}
	}

	/**
	 * Create a new record for the model.
	 */
	public async create(req: Request, res: Response): Promise<void> {
		try {
			const record = await this.prisma[this.modelName].create({
				data: req.body,
			});
			res.status(201).json(record);
		} catch (error) {
			this.handleError(error, res);
		}
	}

	/**
	 * Update a record for the model.
	 */
	public async update(req: Request, res: Response): Promise<void> {
		const { id } = req.params;
		try {
			const record = await this.prisma[this.modelName].update({
				where: { id: Number(id) },
				data: req.body,
			});

			if (!record) {
				throw new NotFoundError(`${this.modelName} with ID ${id} not found`);
			}

			res.json(record);
		} catch (error) {
			this.handleError(error, res);
		}
	}

	/**
	 * Delete a record for the model.
	 */
	public async destroy(req: Request, res: Response): Promise<void> {
		const { id } = req.params;
		try {
			const record = await this.prisma[this.modelName].delete({
				where: { id: Number(id) },
			});

			if (!record) {
				throw new NotFoundError(`${this.modelName} with ID ${id} not found`);
			}

			res.status(204).send();
		} catch (error) {
			this.handleError(error, res);
		}
	}

	/**
	 * Generic error handling method
	 */
	private handleError(error: any, res: Response): void {
		if (error instanceof CustomError) {
			// Handle known custom errors
			res.status(error.statusCode).json(error.json());
		} else {
			// Handle unexpected errors
			const internalError = new UnprocessableEntityError(error.message);
			res.status(internalError.statusCode).json(internalError.json());
		}
	}

	/**
	 * Extract filters from the query parameters.
	 * Override this method in subclasses to customize filter behavior.
	 */
	protected getFilters(req: Request): Record<string, any> {
		const filters: Record<string, any> = {};
		const query = req.body.filterConditions;

		Object.keys(query).forEach((key) => {
			filters[key] = query[key];
		});

		// You can add custom filter transformations here (e.g., type casting, date handling)
		return filters;
	}
}
