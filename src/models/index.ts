import prisma from './prismaClient';

const xprisma = prisma.$extends({
	query: {},
});

const models = {
	Storefront: xprisma.storefront,
};

export default models;
