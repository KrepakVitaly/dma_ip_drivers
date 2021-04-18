#ifndef VCAM_CONTROL_H
#define VCAM_CONTROL_H

#include "vcam.h"
#include "xdma_cdev.h"
#include "xdma_mod.h"

int create_control_device(const char *dev_name);
void destroy_control_device(void);

/* request new virtual camera device */
int request_vcam_device(struct vcam_device_spec *dev_spec, struct xdma_cdev * xcdev);

#endif
