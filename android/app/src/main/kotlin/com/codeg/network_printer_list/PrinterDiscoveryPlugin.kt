package com.codeg.network_printer_list

import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

class PrinterDiscoveryPlugin(private val registrar: Registrar) : MethodChannel.MethodCallHandler {

    private var nsdManager: NsdManager? = null
    private var printerList: MutableList<String> = mutableListOf()

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "network_printer_discovery")
            channel.setMethodCallHandler(PrinterDiscoveryPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "listPrinters") {
            printerList.clear()
            nsdManager = registrar.context().getSystemService(Context.NSD_SERVICE) as NsdManager
            discoverPrinters(result)
        } else {
            result.notImplemented()
        }
    }

    private fun discoverPrinters(result: MethodChannel.Result) {
        val nsdListener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(regType: String) {}

            override fun onServiceFound(serviceInfo: NsdServiceInfo) {
                printerList.add(serviceInfo.serviceName)
            }

            override fun onServiceLost(serviceInfo: NsdServiceInfo) {}

            override fun onDiscoveryStopped(regType: String) {
                result.success(printerList)
                nsdManager?.stopServiceDiscovery(this)
            }

            override fun onStartDiscoveryFailed(regType: String, errorCode: Int) {
                result.error("DISCOVERY_FAILED", "Discovery failed with error code $errorCode", null)
            }

            override fun onStopDiscoveryFailed(regType: String, errorCode: Int) {
                result.error("DISCOVERY_FAILED", "Stop discovery failed with error code $errorCode", null)
            }
        }

        val serviceType = "_ipp._tcp." // Modify this as needed based on the printer service type

        nsdManager?.discoverServices(serviceType, NsdManager.PROTOCOL_DNS_SD, nsdListener)
    }
}
