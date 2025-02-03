import prisma from './prismaClient';

const xprisma = prisma.$extends({
	query: {},
});

const models = {};

export default models;
