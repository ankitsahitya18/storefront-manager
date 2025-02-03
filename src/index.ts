import appInstance from './app';

const PORT = process.env.PORT ?? 3000;

(async () => {
	try {
		await appInstance.initialize();
		appInstance.app.listen(PORT, () => {
			console.log(`Server running on port ${PORT}`);
		});
	} catch (error) {
		console.error('Failed to start server:', error);
		process.exit(1);
	}
})();
