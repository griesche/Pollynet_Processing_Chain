import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from matplotlib.dates import DateFormatter, DayLocator, HourLocator, MinuteLocator, date2num
import os, sys
import scipy.io as spio
import numpy as np
from datetime import datetime, timedelta

def celltolist(xtickstr):
    tmp = []
    for iElement in range(0, len(xtickstr)):
        if not len(xtickstr[iElement][0]):
            tmp.append('')
        else:
            tmp.append(xtickstr[iElement][0][0])

    return tmp

def datenum_to_datetime(datenum):
    """
    Convert Matlab datenum into Python datetime.
    :param datenum: Date in datenum format
    :return:        Datetime object corresponding to datenum.
    """
    days = datenum % 1
    hours = days % 1 * 24
    minutes = hours % 1 * 60
    seconds = minutes % 1 * 60
    return datetime.fromordinal(int(datenum)) \
           + timedelta(days=int(days)) \
           + timedelta(hours=int(hours)) \
           + timedelta(minutes=int(minutes)) \
           + timedelta(seconds=round(seconds)) \
- timedelta(days=366)

def rmext(filename):
    file, _ = os.path.splitext(filename)
    return file

def pollyxt_lacros_display_quasiretrieving(tmpFile, saveFolder):
    '''
    Description
    -----------
    Display the housekeeping data from laserlogbook file.

    Parameters
    ----------
    - tmpFile: the .mat file which stores the housekeeping data.

    Return
    ------ 

    Usage
    -----
    pollyxt_lacros_display_quasiretrieving(tmpFile)

    History
    -------
    2019-01-10. First edition by Zhenping

    Copyright
    ---------
    Ground-based Remote Sensing (TROPOS)
    '''

    if not os.path.exists(tmpFile):
        print('{filename} does not exists.'.format(filename=tmpFile))
        return
    
    # read data
    try:
        mat = spio.loadmat(tmpFile, struct_as_record=True)
        quasi_bsc_532 = mat['quasi_bsc_532'][:]
        quality_mask_532 = mat['quality_mask_532'][:]
        quasi_bsc_1064 = mat['quasi_bsc_1064'][:]
        quality_mask_1064 = mat['quality_mask_1064'][:]
        quasi_pardepol_532 = mat['quasi_pardepol_532'][:]
        quasi_ang_532_1064 = mat['quasi_ang_532_1064'][:]
        height = mat['height'][0][:]
        time = mat['time'][0][:]
        pollyVersion = mat['taskInfo']['pollyVersion'][0][0][0]
        location = mat['campaignInfo']['location'][0][0][0]
        version = mat['processInfo']['programVersion'][0][0][0]
        dataFilename = mat['taskInfo']['dataFilename'][0][0][0]
        xtick = mat['xtick'][0][:]
        xticklabel = mat['xtickstr']
    except Exception as e:
        print('%s has been destroyed' % (tmpFile))
        return

    # meshgrid
    Time, Height = np.meshgrid(time, height)
    quasi_bsc_532 = np.ma.masked_where(quality_mask_532 > 0, quasi_bsc_532)
    quasi_bsc_1064 = np.ma.masked_where(quality_mask_1064 > 0, quasi_bsc_1064)
    quasi_pardepol_532 = np.ma.masked_where(quality_mask_532 > 0, quasi_pardepol_532)
    quasi_ang_532_1064 = np.ma.masked_where(np.logical_or(quality_mask_532 > 0, quality_mask_1064 > 0), quasi_ang_532_1064)

    # define the colormap
    cmap = plt.cm.jet
    cmap.set_bad('w', alpha=1)
    cmap.set_over('w', alpha=1)
    cmap.set_under('k', alpha=1)

    # display quasi backscatter at 532 nm
    fig = plt.figure(figsize=[10, 5])
    ax = fig.add_axes([0.1, 0.15, 0.8, 0.75])
    pcmesh = ax.pcolormesh(Time, Height, quasi_bsc_532 * 1e6, vmin=0, vmax=5, cmap=cmap)
    ax.set_xlabel('UTC', fontweight='semibold', fontsize=14)
    ax.set_ylabel('Height (m)', fontweight='semibold', fontsize=14)

    ax.set_yticks(np.arange(0, 12001, 2000).tolist())
    ax.set_ylim([0, 12000])
    ax.set_xticks(xtick.tolist())
    ax.set_xticklabels(celltolist(xticklabel))

    ax.set_title('Quasi backscatter coefficient at {wave}nm from {instrument} at {location}'.format(wave=532, instrument=pollyVersion, location=location), fontweight='bold', fontsize=12)

    cb_ax = fig.add_axes([0.92, 0.15, 0.02, 0.75])
    cbar = fig.colorbar(pcmesh, cax=cb_ax, ticks=np.arange(0, 5.1, 1), orientation='vertical')
    cbar.ax.tick_params(direction='in', labelsize=10, pad=5)
    cbar.ax.set_title('[$Mm^{-1}*Sr^{-1}$]', fontsize=8)

    fig.text(0.05, 0.04, datenum_to_datetime(time[0]).strftime("%Y-%m-%d"), fontsize=12)
    fig.text(0.8, 0.04, 'Version: {version}'.format(version=version), fontsize=12)

    fig.savefig(os.path.join(saveFolder, '{dataFilename}_Quasi_Bsc_532.png'.format(dataFilename=rmext(dataFilename))), dpi=150)
    plt.close()

    # display quasi backscatter at 1064 nm
    fig = plt.figure(figsize=[10, 5])
    ax = fig.add_axes([0.1, 0.15, 0.8, 0.75])
    pcmesh = ax.pcolormesh(Time, Height, quasi_bsc_1064 * 1e6, vmin=0, vmax=3, cmap=cmap)
    ax.set_xlabel('UTC', fontweight='semibold', fontsize=14)
    ax.set_ylabel('Height (m)', fontweight='semibold', fontsize=14)

    ax.set_yticks(np.arange(0, 12001, 2000).tolist())
    ax.set_ylim([0, 12000])
    ax.set_xticks(xtick.tolist())
    ax.set_xticklabels(celltolist(xticklabel))

    ax.set_title('Quasi backscatter coefficient at {wave}nm from {instrument} at {location}'.format(wave=1064, instrument=pollyVersion, location=location), fontweight='bold', fontsize=12)

    cb_ax = fig.add_axes([0.92, 0.15, 0.02, 0.75])
    cbar = fig.colorbar(pcmesh, cax=cb_ax, ticks=np.arange(0, 3.1, 0.5), orientation='vertical')
    cbar.ax.tick_params(direction='in', labelsize=10, pad=5)
    cbar.ax.set_title('[$Mm^{-1}*Sr^{-1}$]', fontsize=8)

    fig.text(0.05, 0.04, datenum_to_datetime(time[0]).strftime("%Y-%m-%d"), fontsize=12)
    fig.text(0.8, 0.04, 'Version: {version}'.format(version=version), fontsize=12)

    fig.savefig(os.path.join(saveFolder, '{dataFilename}_Quasi_Bsc_1064.png'.format(dataFilename=rmext(dataFilename))), dpi=150)
    plt.close()

    # display quasi particle depolarization ratio at 532 nm
    fig = plt.figure(figsize=[10, 5])
    ax = fig.add_axes([0.1, 0.15, 0.8, 0.75])
    pcmesh = ax.pcolormesh(Time, Height, quasi_pardepol_532, vmin=0, vmax=0.4, cmap=cmap)
    ax.set_xlabel('UTC', fontweight='semibold', fontsize=14)
    ax.set_ylabel('Height (m)', fontweight='semibold', fontsize=14)

    ax.set_yticks(np.arange(0, 12001, 2000).tolist())
    ax.set_ylim([0, 12000])
    ax.set_xticks(xtick.tolist())
    ax.set_xticklabels(celltolist(xticklabel))

    ax.set_title('Quasi particle depolarization ratio at {wave}nm from {instrument} at {location}'.format(wave=532, instrument=pollyVersion, location=location), fontweight='bold', fontsize=12)

    cb_ax = fig.add_axes([0.92, 0.15, 0.02, 0.75])
    cbar = fig.colorbar(pcmesh, cax=cb_ax, ticks=np.arange(0, 0.41, 0.05), orientation='vertical')
    cbar.ax.tick_params(direction='in', labelsize=10, pad=5)
    cbar.ax.set_title('', fontsize=8)

    fig.text(0.05, 0.04, datenum_to_datetime(time[0]).strftime("%Y-%m-%d"), fontsize=12)
    fig.text(0.8, 0.04, 'Version: {version}'.format(version=version), fontsize=12)

    fig.savefig(os.path.join(saveFolder, '{dataFilename}_Quasi_PDR_532.png'.format(dataFilename=rmext(dataFilename))), dpi=150)
    plt.close()

    # display quasi angtroem exponent 532-1064
    fig = plt.figure(figsize=[10, 5])
    ax = fig.add_axes([0.1, 0.15, 0.8, 0.75])
    pcmesh = ax.pcolormesh(Time, Height, quasi_ang_532_1064, vmin=0, vmax=2, cmap=cmap)
    ax.set_xlabel('UTC', fontweight='semibold', fontsize=14)
    ax.set_ylabel('Height (m)', fontweight='semibold', fontsize=14)

    ax.set_yticks(np.arange(0, 12001, 2000).tolist())
    ax.set_ylim([0, 12000])
    ax.set_xticks(xtick.tolist())
    ax.set_xticklabels(celltolist(xticklabel))

    ax.set_title('Quasi BSC Angstoem Exponent 532-1064 from {instrument} at {location}'.format(instrument=pollyVersion, location=location))

    cb_ax = fig.add_axes([0.92, 0.15, 0.02, 0.75])
    cbar = fig.colorbar(pcmesh, cax=cb_ax, ticks=np.arange(0, 2.1, 0.5), orientation='vertical')
    cbar.ax.tick_params(direction='in', labelsize=10, pad=5)
    cbar.ax.set_title('', fontsize=8)

    fig.text(0.05, 0.04, datenum_to_datetime(time[0]).strftime("%Y-%m-%d"), fontsize=12)
    fig.text(0.8, 0.04, 'Version: {version}'.format(version=version), fontsize=12)

    fig.savefig(os.path.join(saveFolder, '{dataFilename}_Quasi_ANGEXP_532_1064.png'.format(dataFilename=rmext(dataFilename))), dpi=150)
    plt.close()

def main():
    pollyxt_lacros_display_quasiretrieving('C:\\Users\\zhenping\\Desktop\\Picasso\\tmp\\tmp.mat', 'C:\\Users\\zhenping\\Desktop\\Picasso\\recent_plots\\POLLYXT_LACROS\\20180517')

if __name__ == '__main__':
    # main()
    pollyxt_lacros_display_quasiretrieving(sys.argv[1], sys.argv[2])