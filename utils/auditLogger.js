

const db = require('../config/database');

const getClientIp = (req) => {
  return req.headers['x-forwarded-for']?.split(',')[0].trim() ||
    req.headers['x-real-ip'] ||
    req.connection?.remoteAddress ||
    req.socket?.remoteAddress ||
    req.connection?.socket?.remoteAddress ||
    'unknown';
};

const logActivity = async ({
  userId = null,
  action,
  entityType = null,
  entityId = null,
  description,
  ipAddress = null,
  metadata = null
}) => {
  try {
    if (!action || !description) {
      return null;
    }

    const metadataJson = metadata ? JSON.stringify(metadata) : null;

    const [rows] = await db.query(
      'CALL sp_create_activity_log(?, ?, ?, ?, ?, ?, ?)',
      [
        userId,
        action,
        entityType,
        entityId,
        description,
        ipAddress,
        metadataJson
      ]
    );

    const logId = rows[0]?.[0]?.log_id;

    return logId;
  } catch (error) {
    return null;
  }
};

const logActivityFromRequest = async (req, params) => {
  const ipAddress = getClientIp(req);
  return logActivity({
    ...params,
    ipAddress
  });
};

module.exports = {
  logActivity,
  logActivityFromRequest,
  getClientIp
};
